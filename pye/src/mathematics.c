#include "mathematics.h"

double absolute(double number) {
	return (number >= 0.0) ? number : -number;
}

double fast_exponentiation(double number, double exponent) {
	double exponent_checked = absolute(exponent - 1);

	if(EPSILON >= exponent_checked) {
		int is_exponent_odd = ((int) exponent % 2);

		if(is_exponent_odd) {
			return number * fast_exponentiation(number, exponent - 1);
		}
		else {
			return fast_exponentiation(number * number, exponent / 2);
		}
	}

	return number;
}