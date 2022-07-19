<?php

declare(strict_types=1);

return [
    'preset' => 'default',

    'ide' => null,

    'exclude' => [
        './cache',
        './logs',
        './reports',
        './vendor',
    ],

    'config' => [
        \NunoMaduro\PhpInsights\Domain\Metrics\Code\Comments::class => [
            \SlevomatCodingStandard\Sniffs\Namespaces\FullyQualifiedClassNameInAnnotationSniff::class,
        ],

        \PHP_CodeSniffer\Standards\Generic\Sniffs\Files\LineLengthSniff::class => [
            'lineLimit'         => 120,
            'absoluteLineLimit' => 160,
            'ignoreComments'    => false,
        ],

        \PhpCsFixer\Fixer\Import\OrderedImportsFixer::class => [
            'imports_order' => [
                'class',
                'const',
                'function',
            ],
            'sort_algorithm' => 'alpha',
        ],

        \PhpCsFixer\Fixer\ClassNotation\OrderedClassElementsFixer::class => [
            'order' => [
                'use_trait',
                'constant_public',
                'constant_protected',
                'constant_private',
                'property_public',
                'property_protected',
                'property_private',
                'construct',
                'destruct',
                'magic',
                'phpunit',
                'method_public',
                'method_protected',
                'method_private',
            ],
            'sort_algorithm' => 'alpha',
        ],

        \PhpCsFixer\Fixer\Operator\BinaryOperatorSpacesFixer::class => [
            'operators' => [
                '=>' => 'align_single_space_minimal',
            ],
            'default' => 'single_space',
        ],

        \PHP_CodeSniffer\Standards\Squiz\Sniffs\WhiteSpace\SuperfluousWhitespaceSniff::class => [
            'ignoreBlankLines' => false,
        ],

        \SlevomatCodingStandard\Sniffs\TypeHints\ReturnTypeHintSpacingSniff::class => [
            'spacesCountBeforeColon' => 0,
        ],

        \SlevomatCodingStandard\Sniffs\Operators\SpreadOperatorSpacingSniff::class => [
            'spacesCountAfterOperator' => 0,
        ],
    ],

    'threads' => 4,
];
