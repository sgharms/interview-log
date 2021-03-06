require 'rspec/autorun'

# I've chosen the stack data structure to keep track of
# our braces. As I'm iterating over the text, I'm checking
# whether the current brace is a closing one. If it is,
# I pop from the stack, if it's an opening brace I add it
# to the stack. Note that never do I compare if a given closing
# brace is properly closing the first element in my stack. I'm
# only checking that stack at the very end to see if it's empty.
# If it is, my braces were properly closed.
#
# For very long inputs, this might not be the best strategy.
# If an invalid bracket is at the start of the string, we'd still
# process the entire thing.

def brace_checker(text)
  stack = prepare(text).each_with_object([]) do |brace, stack|
    closing_brace?(brace) ? stack.pop : stack.push(brace)
  end
  stack.empty?
end

def closing_brace?(brace)
  ["]", ")", "}"].include?(brace)
end

# This remove all text between two matching quotes
# and then any characters that aren't braces and
# remaining quotes
def prepare(text)
  de_quoted = text
    .gsub(/\'(.*?)\'/, "").gsub(/\"(.*?)\"/, "")
  de_quoted.scan(/[\(\)\[\]\{\}'"]/)
end



RSpec.describe "#brace_checker" do
  let(:valid_brackets) {"[()]{}"}
  let(:valid_with_text) {"Lorem, [(Ipsum)]{}"}
  let(:invalid_brackets) {"[()[]"}
  let(:invalid_with_text) {"[Lorem()]Ipsum{"}
  let(:valid_with_quotes) {"(coder)'as\"d]f'(byte)"}
  let(:invalid_with_quotes) {"(coder)']as\"df''(byte)"}

  it "returns true for valid brackets" do
    expect(brace_checker(valid_brackets)).to be true
  end

  it "returns true for valid brackets with text" do
    expect(brace_checker(valid_with_text)).to be true
  end

  it "returns false for invalid brackets" do
    expect(brace_checker(invalid_brackets)).to be false
  end

  it "returns false for invalid brackets with text" do
    expect(brace_checker(invalid_with_text)).to be false
  end

  it "returns true for string with quoted text" do
    expect(brace_checker(valid_with_quotes)).to be true
  end

  it "returns false for invalid string with quoted text" do
    expect(brace_checker(invalid_with_quotes)).to be false
  end

end
