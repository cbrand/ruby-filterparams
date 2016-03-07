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

    rule(:bracket) { lparen >> space? >> clause.as(:clause) >> space? >> rparen }

    rule(:and_clause_element) { parameter | not_operation | bracket }
    rule(:and_clause) {
      and_clause_element.as(:left) >> space? >> and_operator.as(:operator) >> space? >> (and_clause | and_clause_element).as(:right)
    }
    rule(:or_clause_element) { and_clause | parameter | not_operation | bracket }
    rule(:or_clause) {
      or_clause_element.as(:left) >> space? >> or_operator.as(:operator) >> space? >> clause.as(:right)
    }
    rule(:not_operation) { str('!').as(:operator) >> space? >> clause.as(:clause) }

    rule(:clause) { or_clause | and_clause | parameter | bracket | not_operation }

    rule(:binding) { space? >> clause >> space? }

    root(:binding)
  end
end
