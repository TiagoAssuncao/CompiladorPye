#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "linked_list.h"

/* The suite initialization function.
 * Opens the temporary file used by the tests.
 * Returns zero on success, non-zero otherwise.
 */
int init_suite1(void)
{

}

/* The suite cleanup function.
 * Closes the temporary file used by the tests.
 * Returns zero on success, non-zero otherwise.
 */
int clean_suite1(void)
{

}

//first Test
void testFIRST(void){

   CU_ASSERT( 1 == 1);
}

int main()
{
	 CU_pSuite pSuite = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite_1", NULL, NULL);
   if (NULL == pSuite) 
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* add the tests to the suite */
   if ((NULL == CU_add_test(pSuite, "first test()", testFIRST)))
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();
   CU_cleanup_registry();
   return CU_get_error();


	return 0;
}
