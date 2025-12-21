import axios from 'axios';

export class BrevoClient {
  private apiKey: string;
  private apiUrl: string;

  constructor() {
    this.apiKey = process.env.BREVO_API_KEY!;
    this.apiUrl = process.env.EMAIL_BRAVO_URL!;
  }

  async sendTransactionalEmail(emailData: {
    sender: { name: string; email: string };
    to: Array<{ email: string; name: string }>;
    subject: string;
    htmlContent: string;
  }): Promise<{ messageId: string }> {
    try {
      const response = await axios.post(this.apiUrl, emailData, {
        headers: {
          accept: 'application/json',
          'api-key': this.apiKey,
          'content-type': 'application/json',
        },
      });

      return { messageId: response.data.messageId };
    } catch (error) {
      if (axios.isAxiosError(error)) {
        throw new Error(
          `Failed to send email: ${error.response?.data?.message || error.message}`,
        );
      }
      throw error;
    }
  }
}
