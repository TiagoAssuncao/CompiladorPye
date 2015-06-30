#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "mathematics.h"

int init_suite(void){
	return 0;
} 

int clean_suite(void){
	return 0;
}

/* Absolute tests */
void testAbsoluteValue(void){
	CU_ASSERT_EQUAL(6, absolute(6));
	CU_ASSERT_EQUAL(6, absolute(-6));
}

/* Exponentiation test */
void testResultValue(void){

}

int main()
{
	CU_pSuite pSuiteAbsolute = NULL;
	CU_pSuite pSuiteExponentiation = NULL;

	/* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
   	return CU_get_error();

   /* add a suite to the registry */
   pSuiteAbsolute = CU_add_suite("Suite Absolute Value", init_suite, clean_suite);
   pSuiteExponentiation = CU_add_suite("Suite Exponentiation", init_suite, clean_suite);

   if ((NULL == pSuiteAbsolute) 
      || (NULL == pSuiteExponentiation)
      )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Absolute */
   if( (NULL == CU_add_test(pSuiteAbsolute, "Get expected value()", testAbsoluteValue)) )
   {
      CU_cleanup_registry();
      return CU_get_error();   
   }

   /* Suite Exponentiation */
   if( (NULL == CU_add_test(pSuiteExponentiation, "Get expected value()", testResultValue)) )
   {
      CU_cleanup_registry();
      return CU_get_error();   
   }

   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();

   return 0;
}