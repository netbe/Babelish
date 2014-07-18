require "test_helper"
class TestXcodeMacros < Test::Unit::TestCase
  def test_process
    keys = ["LS_TITLE", "LS_BUTTON"]
    table = "Localizable"
    content = Babelish::XcodeMacros.process(table, keys)
    expected_output = String.new(<<-EOS)
#define LS_TITLE NSLocalizedStringFromTable(@"LS_TITLE",@"Localizable",@"")
#define LS_BUTTON NSLocalizedStringFromTable(@"LS_BUTTON",@"Localizable",@"")
    EOS
    assert_equal expected_output, content
  end

  def test_write_macros
    keys = ["LS_TITLE", "LS_BUTTON"]
    table = "Localizable"
    Babelish::XcodeMacros.write_macros("Babelish.h", table, keys)
    expected_output = String.new(<<-EOS)
#define LS_TITLE NSLocalizedStringFromTable(@"LS_TITLE",@"Localizable",@"")
#define LS_BUTTON NSLocalizedStringFromTable(@"LS_BUTTON",@"Localizable",@"")
    EOS
    assert File.exists?("Babelish.h")
    assert expected_output, File.read("Babelish.h")
  end
end
