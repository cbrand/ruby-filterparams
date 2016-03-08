require 'parslet'

module Filterparams
  class BindingParser < Parslet::Parser
    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    rule(:lparen) { str('(') >> space? }
    rule(:rparen) { str(')') >> space? }

    rule(:and_operator) { str('&') }
    rule(:or_operator) { str('|') }

    rule(:parameter) { match('[\w\-\_]').repeat(1).as(:parameter) }

    rule(:bracket) do
      lparen >> space? >> clause.as(:clause) >> space? >> rparen
    end

    rule(:and_clause_element) { parameter | not_operation | bracket }
    rule(:and_clause) do
      and_clause_element.as(:left) >> space? >>
        and_operator.as(:operator) >> space? >>
        (and_clause | and_clause_element).as(:right)
    end
    rule(:or_clause_element) do
      and_clause | parameter | not_operation | bracket
    end
    rule(:or_clause) do
      or_clause_element.as(:left) >> space? >>
        or_operator.as(:operator) >> space? >>
        clause.as(:right)
    end
    rule(:inner_not) { bracket | parameter | not_operation }
    rule(:not_operation) do
      str('!').as(:operator) >> space? >> inner_not.as(:clause)
    end

    rule(:clause) do
      or_clause | and_clause | parameter | bracket | not_operation
    end

    rule(:binding) { space? >> clause >> space? }

    root(:binding)
  end
end
