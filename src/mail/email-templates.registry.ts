import { EmailTemplate } from './types/email.types';

interface TemplateConfig {
  template: EmailTemplate;
  defaultSubject: string;
}

export const EMAIL_TEMPLATES_REGISTRY: Record<string, TemplateConfig> = {
  forgotPassword: {
    template: EmailTemplate.FORGOT_PASSWORD,
    defaultSubject: 'Reset Your Password - Recipe App',
  },
  welcome: {
    template: EmailTemplate.WELCOME,
    defaultSubject: 'Welcome to Recipe App!',
  },
  verifyEmail: {
    template: EmailTemplate.VERIFY_EMAIL,
    defaultSubject: 'Verify Your Email - Recipe App',
  },
  passwordChanged: {
    template: EmailTemplate.PASSWORD_CHANGED,
    defaultSubject: 'Your Password Has Been Changed',
  },
    registerEmail: {
    template: EmailTemplate.SIGNUP_CONFIRMATION,
    defaultSubject: 'Welcome to Recipe App - Registration Successful',
  },
};
