import { HttpException, HttpStatus, Injectable, Logger } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';
import * as Handlebars from 'handlebars';
import { BrevoClient } from './brevo-client';
import { EMAIL_CONFIG } from './config/email.config';
import {
  EmailData,
  EmailRecipient,
  EmailResponse,
  EmailTemplate,
  TemplateData,
} from './types/email.types';
import { EMAIL_TEMPLATES_REGISTRY } from './email-templates.registry';

@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);
  private brevoClient: BrevoClient;
  private templateCache: Map<string, HandlebarsTemplateDelegate> = new Map();

  constructor() {
    this.brevoClient = new BrevoClient();
  }

  async sendForgotPasswordEmail(
    to: string,
    name: string,
    resetLink: string,
    customSubject?: string,
  ): Promise<EmailResponse> {
    return this.sendTemplatedEmail(
      'forgotPassword',
      [{ email: to, name }],
      { name, resetLink },
      customSubject,
    );
  }

  async sendTemplatedEmail(
    templateKey: keyof typeof EMAIL_TEMPLATES_REGISTRY,
    recipients: EmailRecipient[],
    templateData: TemplateData,
    customSubject?: string,
  ): Promise<EmailResponse> {
    try {
      const templateConfig = EMAIL_TEMPLATES_REGISTRY[templateKey];
      if (!templateConfig) {
        throw new Error(`Template "${templateKey}" not found in registry`);
      }

      const emailConfig = EMAIL_CONFIG({
        subject: customSubject || templateConfig.defaultSubject,
      });

      const html = this.renderTemplate(templateConfig.template, templateData);

      const emailData: EmailData = {
        sender: emailConfig.sender,
        to: recipients,
        subject: emailConfig.subject,
        htmlContent: html,
      };

      const result = await this.brevoClient.sendTransactionalEmail(emailData);

      this.logger.log(
        `Email "${templateKey}" sent successfully to ${recipients.map((r) => r.email).join(', ')}`,
      );

      return {
        success: true,
        message: 'Email sent successfully',
        messageId: result.messageId,
      };
    } catch (error) {
      this.logger.error(
        `Failed to send email "${templateKey}": ${error.message}`,
        error.stack,
      );

      return {
        success: false,
        message: 'Failed to send email',
      };
    }
  }

  private renderTemplate(
    templateName: EmailTemplate,
    data: TemplateData,
  ): string {
    try {
      let template = this.templateCache.get(templateName);

      if (!template) {
        const templatePath = path.join(__dirname, 'templates', templateName);
        const templateSource = fs.readFileSync(templatePath, 'utf-8');
        template = Handlebars.compile(templateSource);
        this.templateCache.set(templateName, template);
      }

      return template(data);
    } catch (error) {
      this.logger.error(
        `Failed to render template "${templateName}": ${error.message}`,
      );
      throw error;
    }
  }
}
