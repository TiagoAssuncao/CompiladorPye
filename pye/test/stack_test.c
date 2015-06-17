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

/* pop_element suite */
int init_suite_pop_element(void)
{
   stack = new_stack();

   insert_scope_on_stack(stack, "insert1");
   insert_scope_on_stack(stack, "insert2");
   insert_scope_on_stack(stack, "insert3");

   return 0;
}


/* add tests to the suite Free Linked List*/
void test(void)
{
   CU_ASSERT(1 == 1);
}

/* New stack tests */
void  testNewStack(void){
   CU_ASSERT_PTR_NOT_NULL(stack);
}

/* Pop element tests */
void testPopElement(void){
   stack_node *second_element = stack->top->previous;
   pop_element(stack);

   CU_ASSERT_PTR_EQUAL(second_element, stack->top);
   CU_ASSERT_EQUAL(stack->length, 2);
}
void testPopElementTopNextNull(void){
   pop_element(stack);

   CU_ASSERT_PTR_NULL(stack->top->next);
}

int main()
{
   
    CU_pSuite pSuite = NULL;
    CU_pSuite pSuiteNew = NULL;
    CU_pSuite pSuitePopElement = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite", init_suite, clean_suite);
   pSuiteNew = CU_add_suite("Suite New stack", init_suite, clean_suite);
   pSuitePopElement = CU_add_suite("Suite Pop Element", init_suite_pop_element, clean_suite);

   if ((NULL == pSuite) || 
      (NULL == pSuiteNew) ||
      (NULL == pSuitePopElement)
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

   /* Suite New stack tests*/
   if( (NULL == CU_add_test(pSuiteNew, "Create stack()", testNewStack)) )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Pop Element */
   if ( (NULL == CU_add_test(pSuitePopElement, "Pop element()", testPopElement)) ||
   (NULL == CU_add_test(pSuitePopElement, "Top next element is NULL()", testPopElementTopNextNull))
   )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }


   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();


   return 0;
}
