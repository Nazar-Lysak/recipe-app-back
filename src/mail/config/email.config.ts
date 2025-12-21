interface EmailConfigParams {
  subject?: string;
}

export const EMAIL_CONFIG = (params?: EmailConfigParams) => {
  return {
    brevo: {
      apiKey: process.env.BREVO_API_KEY!,
      apiUrl: process.env.EMAIL_BRAVO_URL!,
    },
    sender: {
      name: process.env.APPLICATION_NAME!,
      email: process.env.EMAIL_SENDER_EMAIL!,
    },
    subject: params?.subject || process.env.APPLICATION_NAME!,
  };
};
