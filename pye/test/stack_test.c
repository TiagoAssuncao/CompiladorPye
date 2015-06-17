#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "stack.h"


stack_header *stack = NULL;

int init_suiteNewStack(void)
{
   stack = new_stack();
   return 0;
}
int clean_suiteNewStack(void)
{
   return 0;
}

/* Test for insert element on stack */
int init_suiteInsert(void)
{
   stack = new_stack();
   stack = insert_scope_on_stack(stack,"firstScope");
   return 0;
}
int clean_suiteInsert(void)
{
   return 0;
}

/* Test insert Element*/
void testInsertElement(void)
{
   CU_ASSERT(stack->length == 1);
   stack_node *node = get_top(stack);

   CU_ASSERT_PTR_NULL(node->next);
   CU_ASSERT_PTR_NULL(node->previous);
   CU_ASSERT_STRING_EQUAL(node->scope_name, "firstScope");
}

void testInsertSecondElement(void)
{
   stack = insert_scope_on_stack(stack,"secondScope");

   CU_ASSERT(stack->length == 2);
   stack_node *node = get_top(stack);

   CU_ASSERT_STRING_EQUAL(node->scope_name, "secondScope");   
   CU_ASSERT_PTR_NULL(node->next);
   CU_ASSERT_PTR_NOT_NULL(node->previous);
   
   stack_node* previousNode = node->previous;
   CU_ASSERT_STRING_EQUAL(previousNode->scope_name, "firstScope");
}

/*New stack tests*/
void testNewStack(void)
{
   CU_ASSERT_PTR_NOT_NULL(stack);

}

int main()
{
   
    CU_pSuite pSuiteInsert = NULL;
    CU_pSuite pSuiteNew = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuiteInsert = CU_add_suite("Suite Insert Element on Stack", init_suiteInsert, clean_suiteInsert);
   pSuiteNew = CU_add_suite("Suite New stack", init_suiteNewStack, clean_suiteNewStack);

   if ( (NULL == pSuiteInsert) 
      || (NULL == pSuiteNew) )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Insert */
   if( (NULL == CU_add_test(pSuiteInsert, "Insert Element on stack()", testInsertElement) ) 
      || (NULL == CU_add_test(pSuiteInsert, "Insert Second Element on stack()", testInsertSecondElement) ))
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
