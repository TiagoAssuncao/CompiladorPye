#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>


int init_suite(void)
{
   // Run commands to prepare test enviroment
   // system("command");
   return 0;
}
int clean_suite(void)
{
   return 0;
}

/* add tests to the suite Free Linked List*/
void test(void)
{
   CU_ASSERT(1 == 1);
}

int main()
{
   
    CU_pSuite pSuite = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite", init_suite, clean_suite);

   if (NULL == pSuite)
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Free */
   if( (NULL == CU_add_test(pSuite, "free linked list()", test) ))
   {
      CU_cleanup_registry();
      return CU_get_error();
   }


   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();


	return 0;
}
