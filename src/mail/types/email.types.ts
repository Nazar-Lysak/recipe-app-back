export interface EmailRecipient {
  email: string;
  name: string;
}

export interface EmailSender {
  name: string;
  email: string;
}

export interface EmailData {
  sender: EmailSender;
  to: EmailRecipient[];
  subject: string;
  htmlContent: string;
}

export interface EmailResponse {
  success: boolean;
  message: string;
  messageId?: string;
}

export enum EmailTemplate {
  FORGOT_PASSWORD = 'forgot-password.hbs',
  WELCOME = 'welcome.hbs',
  VERIFY_EMAIL = 'verify-email.hbs',
  PASSWORD_CHANGED = 'password-changed.hbs',
}

export interface TemplateData {
  [key: string]: any;
}
