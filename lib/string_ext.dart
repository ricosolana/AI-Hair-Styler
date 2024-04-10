extension MyStringExtension on String {
  String limit(int maxLength, 
    {
      //int offset = 0,
      //String format = '{}{}{}',
      bool clipFromStart = false
    }
  ) {
    if (clipFromStart) {
      return length > maxLength ? '...${substring(length - maxLength)}': this;
    } else {
      return length > maxLength ? '${substring(0, maxLength)}...': this;
    }
  }
}
