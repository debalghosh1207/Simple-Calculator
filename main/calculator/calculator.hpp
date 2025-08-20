#ifndef CALCULATOR_HPP
#define CALCULATOR_HPP

#include "./operations/operations.hpp"

#include "string"

typedef std::string String;

class Calculator {
public:
  static float evaluate(String operation, int first, int second);
};

#endif
