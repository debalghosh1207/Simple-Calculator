project('basic-calculator')

includes = [
  include_directories('./main/calculator'),
  include_directories('./main/calculator/operations'),
]

sources = [
  './main/calculator/operations/operations.cpp',
  './main/calculator/calculator.cpp'
  './main/main_calc.cpp'
]

executable(
  'basic-calculator',
  sources,
  include_directories: includes,
  install: true,
  install_dir: get_option('bindir')
)
