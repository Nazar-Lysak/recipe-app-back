export interface ChatParticipantProfile {
  id: string;
  firstName: string;
  lastName: string;
  avatar: string;
}

export interface ChatParticipant {
  email: string;
  id: string;
  username: string;
  profile: ChatParticipantProfile;
}

export interface FormattedChat {
  id: string;
  participants: ChatParticipant[];
  messages: any[];
  chatWith?: ChatParticipant | null;
}

export interface GetMyChatsResponse {
  chats: FormattedChat[];
  chatsCount: number;
}

export interface GetSingleChatResponse {
  chats: FormattedChat;
  chatsCount: number;
}
