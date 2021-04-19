project('ttt', ['c', 'vala'])

ttt_sources = [
  'ttt.vala',
]

ttt_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk+-3.0'),
]

executable('ttt', ttt_sources,
  vala_args: '--target-glib=2.58',  dependencies: ttt_deps,
  install: true,
)
