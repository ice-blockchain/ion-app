// SPDX-License-Identifier: ice License 1.0

final mockedArticleContent = [
  {'insert': 'Header1'},
  {
    'insert': '\n',
    'attributes': {'header': 1},
  },
  {'insert': 'Header2'},
  {
    'insert': '\n',
    'attributes': {'header': 2},
  },
  {'insert': 'Header3'},
  {
    'insert': '\n',
    'attributes': {'header': 3},
  },
  {'insert': 'Regular\n'},
  {
    'insert': 'Bold',
    'attributes': {'bold': true},
  },
  {'insert': '\n'},
  {
    'insert': 'Italic',
    'attributes': {'italic': true},
  },
  {'insert': '\n'},
  {
    'insert': 'Underlined',
    'attributes': {'underline': true},
  },
  {'insert': '\n'},
  {
    'insert': 'Link',
    'attributes': {'link': 'http://example.com'},
  },
  {'insert': '\n\nList dots\nOne'},
  {
    'insert': '\n',
    'attributes': {'list': 'bullet'},
  },
  {'insert': 'Two'},
  {
    'insert': '\n',
    'attributes': {'list': 'bullet'},
  },
  {'insert': 'Three'},
  {
    'insert': '\n',
    'attributes': {'list': 'bullet'},
  },
  {'insert': '\nQuote\nQuote example'},
  {
    'insert': '\n',
    'attributes': {'blockquote': true},
  },
  {'insert': '\n'},
  {
    'insert': '@Timechain',
    'attributes': {'mention': '@Timechain'},
  },
  {'insert': ' \n\nHashtags\n'},
  {
    'insert': '#Habits',
    'attributes': {'hashtag': '#Habits'},
  },
  {'insert': ' \n\nSeparator\n\n'},
  {
    'insert': {'custom': '{"text-editor-separator":""}'},
  },
  {'insert': '\nAnd code example\n\n'},
  {
    'insert': {'custom': '{"text-editor-code":""}'},
  },
  {'insert': '\n\n\n'},
];
