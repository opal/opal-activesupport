class String
  def parameterize
    self.downcase.strip.gsub(/\W+/, '-')
  end

  def dasherize
    `#{self}.replace(/[-_\\s]+/g, '-')
            .replace(/([A-Z\\d]+)([A-Z][a-z])/g, '$1-$2')
            .replace(/([a-z\\d])([A-Z])/g, '$1-$2')
            .toLowerCase()`
  end

  def demodulize
    %x{
      var idx = #{self}.lastIndexOf('::');

      if (idx > -1) {
        return #{self}.substr(idx + 2);
      }

      return #{self};
    }
  end

  def underscore
    `#{self}.replace(/[-\\s]+/g, '_')
    .replace(/([A-Z\\d]+)([A-Z][a-z])/g, '$1_$2')
    .replace(/([a-z\\d])([A-Z])/g, '$1_$2')
    .toLowerCase()`
  end
end
