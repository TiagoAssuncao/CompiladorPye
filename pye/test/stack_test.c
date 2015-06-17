#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "stack.h"

stack_header *stack = NULL;

int init_suite(void)
{
   stack = new_stack();

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

/*New stack tests*/
void  testNewStack(void){
   CU_ASSERT_PTR_NOT_NULL(stack);
}

int main()
{
   
    CU_pSuite pSuite = NULL;
    CU_pSuite pSuiteNew = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite", init_suite, clean_suite);
   pSuiteNew = CU_add_suite("Suite New stack", init_suite, clean_suite);

   if ((NULL == pSuite) || 
      (NULL == pSuiteNew)
      )
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

   /* Suite New stack*/
   if( (NULL == CU_add_test(pSuiteNew, "Create stack()", testNewStack)) )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }



   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();


   return 0;
}
