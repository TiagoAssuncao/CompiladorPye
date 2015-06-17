#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "stack.h"


stack_header *stack = NULL;

int init_suite_new_stack(void)
{
   stack = new_stack();
   return 0;
}
int clean_suite(void)
{
   return 0;
}

int init_suiteGetTop(void)
{
   stack = new_stack();
   return 0;
}
int clean_suiteGetTop(void)
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
   // Cleaning the stack
   while(get_top(stack)){
      pop_element(stack);
   }

   return 0;
}

/*New stack tests*/
void testNewStack(void)
{
   CU_ASSERT_PTR_NOT_NULL(stack);
}

void testGetTopWithoutElement(void)
{
   stack_node* node = get_top(stack);
   CU_ASSERT_PTR_NULL(node);
}

void testGetTopWithElement(void)
{
   insert_scope_on_stack(stack, "newScope");
   stack_node* node = get_top(stack);
   CU_ASSERT_STRING_EQUAL(node->scope_name, "newScope");
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

/* Pop element tests */
void testPopElement(void)
{
   stack_node *second_element = stack->top->previous;
   pop_element(stack);

   CU_ASSERT_PTR_EQUAL(second_element, stack->top);
   CU_ASSERT_EQUAL(stack->length, 2);
}
void testPopElementTopNextNull(void)
{
   pop_element(stack);
   CU_ASSERT_PTR_NULL(stack->top->next);
}

int main()
{
   
    CU_pSuite pSuiteInsert = NULL;
    CU_pSuite pSuiteNew = NULL;
    CU_pSuite pSuiteGetTop = NULL;
    CU_pSuite pSuitePopElement = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuiteInsert = CU_add_suite("Suite Insert Element on Stack", init_suiteInsert, clean_suiteInsert);
   pSuiteGetTop = CU_add_suite("Suite Get Top", init_suiteGetTop, clean_suiteGetTop);
   pSuiteNew = CU_add_suite("Suite New stack", init_suite_new_stack, clean_suite);
   pSuitePopElement = CU_add_suite("Suite Pop Element", init_suite_pop_element, clean_suite);


   if ((NULL == pSuiteNew) 
      || (NULL == pSuitePopElement) 
      || (NULL == pSuiteInsert)
      )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Get top */
   if( (NULL == CU_add_test(pSuiteGetTop, "Get top of Stack Without element()", testGetTopWithoutElement)) 
      || (NULL == CU_add_test(pSuiteGetTop, "Get top of Stack With element()", testGetTopWithElement)) )
   {
      CU_cleanup_registry();
      return CU_get_error();   
   }

   /* Suite Insert */
   if( (NULL == CU_add_test(pSuiteInsert, "Insert Element on stack()", testInsertElement) ) 
      || (NULL == CU_add_test(pSuiteInsert, "Insert Second Element on stack()", testInsertSecondElement) ))

   /* Suite New stack tests*/
   if( (NULL == CU_add_test(pSuiteNew, "Create stack()", testNewStack)) )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Pop Element */
   if ( (NULL == CU_add_test(pSuitePopElement, "Pop element()", testPopElement)) 
      || (NULL == CU_add_test(pSuitePopElement, "Top next element is NULL()", testPopElementTopNextNull))
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
