enum MessageEnum {
  text('TEXT'),
  image('IMAGE'),
  audio('AUDIO'),
  video('VIDEO'),
  gif('GIF');

  const MessageEnum(this.type);
  final String type;
}

// Using an extension
// Enhanced enums

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'AUDIO':
        return MessageEnum.audio;
      case 'IMAGE':
        return MessageEnum.image;
      case 'TEXT':
        return MessageEnum.text;
      case 'GIF':
        return MessageEnum.gif;
      case 'VIDEO':
        return MessageEnum.video;
      default:
        return MessageEnum.text;
    }
  }
}
