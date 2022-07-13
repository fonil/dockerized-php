<?php

$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__)
    ->ignoreDotFiles(true)
    ->exclude([
        './.cache',
        './.logs',
        './.reports',
        './vendor',
    ])
    ->name('.php-cs-fixer.php')
;

$config = new PhpCsFixer\Config();
return $config->setRules([
        '@PSR12' => true,
        '@PHP81Migration' => true,
        '@PHP80Migration:risky' => false,
        'array_indentation' => true,
        'array_syntax' => ['syntax' => 'short'],
        'binary_operator_spaces' => ['operators' => ['=>' => 'align_single_space_minimal']],
        'class_attributes_separation' => ['elements' => ['const' => 'none', 'method' => 'one', 'property' => 'none', 'trait_import' => 'none', 'case' => 'none']],
        'class_definition' => ['single_line' => true],
        'combine_consecutive_unsets' => false,
        'concat_space' => ['spacing' => 'one'],
        'constant_case' => ['case' => 'lower'],
        'declare_equal_normalize' => true,
        'full_opening_tag' => false,
        'function_typehint_space' => true,
        'include' => true,
        'lowercase_cast' => true,
        'multiline_whitespace_before_semicolons' => true,
        'no_extra_blank_lines' => ['tokens' => ['break', 'case', 'continue', 'curly_brace_block', 'default', 'extra', 'parenthesis_brace_block', 'return', 'square_brace_block', 'switch', 'throw', 'use']],
        'no_multiline_whitespace_around_double_arrow' => true,
        'no_spaces_around_offset' => true,
        'no_spaces_inside_parenthesis' => true,
        'no_trailing_comma_in_list_call' => false,
        'no_trailing_comma_in_singleline_array' => false,
        'no_trailing_whitespace' => true,
        'no_unneeded_control_parentheses' => true,
        'no_unused_imports' => true,
        'no_whitespace_before_comma_in_array' => true,
        'no_whitespace_in_blank_line' => true,
        'not_operator_with_space' => false,
        'object_operator_without_whitespace' => true,
        'ordered_class_elements' => true,
        'ordered_imports' => ['imports_order' => ['class', 'function', 'const'], 'sort_algorithm' => 'alpha'],
        'single_line_comment_style' => true,
        'single_quote' => false,
        'switch_case_space' => false,
        'ternary_operator_spaces' => true,
        'trailing_comma_in_multiline' => ['elements' => ['arrays']],
        'trim_array_spaces' => true,
        'unary_operator_spaces' => true,
        'whitespace_after_comma_in_array' => true,
    ])
    ->setFinder($finder)
;
