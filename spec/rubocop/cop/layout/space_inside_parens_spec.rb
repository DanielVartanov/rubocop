# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::SpaceInsideParens, :config do
  context 'when EnforcedStyle is no_space' do
    let(:cop_config) { { 'EnforcedStyle' => 'no_space' } }

    it 'registers an offense for spaces inside parens' do
      expect_offense(<<~RUBY)
        f( 3)
          ^ Space inside parentheses detected.
        g = (a + 3 )
                  ^ Space inside parentheses detected.
        f( )
          ^ Space inside parentheses detected.
      RUBY

      expect_correction(<<~RUBY)
        f(3)
        g = (a + 3)
        f()
      RUBY
    end

    it 'registers an offense for space around heredoc start' do
      expect_offense(<<~'RUBY')
        f( <<~HEREDOC )
                     ^ Space inside parentheses detected.
          ^ Space inside parentheses detected.
          This is my text
        HEREDOC
      RUBY

      expect_correction(<<~RUBY)
        f(<<~HEREDOC)
          This is my text
        HEREDOC
      RUBY
    end

    it 'accepts parentheses in block parameter list' do
      expect_no_offenses(<<~RUBY)
        list.inject(Tms.new) { |sum, (label, item)|
        }
      RUBY
    end

    it 'accepts parentheses with no spaces' do
      expect_no_offenses('split("\\n")')
    end

    it 'accepts parentheses with line break' do
      expect_no_offenses(<<~RUBY)
        f(
          1)
      RUBY
    end

    it 'accepts parentheses with comment and line break' do
      expect_no_offenses(<<~RUBY)
        f( # Comment
          1)
      RUBY
    end
  end

  context 'when EnforcedStyle is space' do
    let(:cop_config) { { 'EnforcedStyle' => 'space' } }

    it 'registers an offense for no spaces inside parens' do
      expect_offense(<<~RUBY)
        f( 3)
            ^ No space inside parentheses detected.
        g = (a + 3 )
             ^ No space inside parentheses detected.
        split("\\n")
              ^ No space inside parentheses detected.
                  ^ No space inside parentheses detected.
      RUBY

      expect_correction(<<~RUBY)
        f( 3 )
        g = ( a + 3 )
        split( "\\n" )
      RUBY
    end

    it 'registers an offense for space inside empty parens' do
      expect_offense(<<~RUBY)
        f( )
          ^ Space inside parentheses detected.
      RUBY

      expect_correction(<<~RUBY)
        f()
      RUBY
    end

    it 'registers an offense in block parameter list with no spaces' do
      expect_offense(<<~RUBY)
        list.inject( Tms.new ) { |sum, (label, item)|
                                        ^ No space inside parentheses detected.
                                                   ^ No space inside parentheses detected.
        }
      RUBY

      expect_correction(<<~RUBY)
        list.inject( Tms.new ) { |sum, ( label, item )|
        }
      RUBY
    end

    it 'registers an offense for no space around heredoc start' do
      expect_offense(<<~RUBY)
        f(<<~HEREDOC)
                    ^ No space inside parentheses detected.
          ^ No space inside parentheses detected.
          This is my text
        HEREDOC
      RUBY

      expect_correction(<<~RUBY)
        f( <<~HEREDOC )
          This is my text
        HEREDOC
      RUBY
    end

    it 'accepts empty parentheses without spaces' do
      expect_no_offenses('f()')
    end

    it 'accepts parentheses with spaces' do
      expect_no_offenses(<<~RUBY)
        f( 3 )
        g = ( a + 3 )
        split( "\\n" )
      RUBY
    end

    it 'accepts parentheses with line break' do
      expect_no_offenses(<<~RUBY)
        f(
          1 )
      RUBY
    end

    it 'accepts parentheses with comment and line break' do
      expect_no_offenses(<<~RUBY)
        f( # Comment
          1 )
      RUBY
    end
  end
end
