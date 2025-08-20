# Simple Makefile for testing (when CMake is not available)
CXX = g++
CXXFLAGS = -std=c++11 -I. -I./main -I./main/calculator -I./main/calculator/operations
TARGET = basic-calculator
SOURCES = main/main_calc.cpp main/calculator/calculator.cpp main/calculator/operations/operations.cpp

# Create version header manually for testing
version.h:
	@echo "#ifndef VERSION_H" > version.h
	@echo "#define VERSION_H" >> version.h
	@echo "#define PROJECT_VERSION_MAJOR 1" >> version.h
	@echo "#define PROJECT_VERSION_MINOR 0" >> version.h
	@echo "#define PROJECT_VERSION_PATCH 0" >> version.h
	@echo "#define PROJECT_VERSION \"1.0.0\"" >> version.h
	@echo "#define PROJECT_NAME \"basic-calculator\"" >> version.h
	@echo "#endif // VERSION_H" >> version.h

$(TARGET): version.h $(SOURCES)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SOURCES)

clean:
	rm -f $(TARGET) version.h

test: $(TARGET)
	./$(TARGET) add 5 3
	./$(TARGET) --version

.PHONY: clean test version.h
