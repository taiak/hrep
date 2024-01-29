# HrefRegexpParser
class HREP
    # splits lines into parts according to the given regexp rule. It extracts the block_list containing the words and checks if the must_have_list contains all the words.
    def self.parse(
          regexp: nil,
          lines:  [], 
          block_list: [], 
          must_have_list: [])
      return false unless check_given_parameters(lines, block_list, must_have_list, regexp)
      return [] if lines.empty?

      lines
        .select { |line| line.match?(regexp) }
        .map    { |line| line.match(regexp).captures }
        .select { |captures| include_all_must_have_word?(must_have_list, captures) }
        .reject { |captures| include_any_block_list_word?(block_list, captures) }
    end

    private
    # check given initial parameters
    # if any given parameter not exist or not eligible return false
    # if given regexp has no named regex field return nil
    # 
    def self.check_given_parameters(lines, block_list, must_have_list, regexp)
      raise Exception.new "The 'lines' parameter is not appropriate." unless lines || lines.class == Array
      
      return [] if lines.empty?
      raise Exception.new "The 'block_list' parameter is not appropriate." unless block_list || block_list.class == Array 
      
      raise Exception.new "The 'must_have_list' parameter is not appropriate." unless must_have_list || must_have_list.class == Array

      raise Exception.new "The 'regexp' parameter is not appropriate." unless regexp || regexp.class == Regexp 
      field_names = regexp.names
      return nil if field_names.empty?
      
      return true
    end

    def self.include_all_must_have_word?(must_have_list, captures)
      must_have_list.all? { |must_have| captures.any? { |capture| capture.match(must_have) || must_have.match(capture) } }
    end

    def self.include_any_block_list_word?(block_list, captures)
      captures.any? { |capture| block_list.any? { |word| capture.include?(word) } }
    end
end