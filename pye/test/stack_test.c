#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "stack.h"

stack_header *header = NULL;

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

/* Test for insert element on stack */
int init_suiteInsert(void)
{
   header = new_stack();
   header = insert_scope_on_stack(header,"firstScope");
   return 0;
}
int clean_suiteInsert(void)
{
   return 0;
}

/* Test insert Element*/
void testInsertElement(void)
{
   CU_ASSERT(header->length == 1);
   stack_node *node = get_top(header);

   CU_ASSERT_PTR_NULL(node->next);
   CU_ASSERT_PTR_NULL(node->previous);
   CU_ASSERT_STRING_EQUAL(node->scope_name, "firstScope");
}

void testInsertSecondElement(void)
{
   header = insert_scope_on_stack(header,"secondScope");

   CU_ASSERT(header->length == 2);
   stack_node *node = get_top(header);

   CU_ASSERT_STRING_EQUAL(node->scope_name, "secondScope");   
   CU_ASSERT_PTR_NULL(node->next);
   CU_ASSERT_PTR_NOT_NULL(node->previous);
   
   stack_node* previousNode = node->previous;
   CU_ASSERT_STRING_EQUAL(previousNode->scope_name, "firstScope");
   
}

int main()
{
   
    CU_pSuite pSuite = NULL;
    CU_pSuite pSuiteInsert = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite", init_suite, clean_suite);
   pSuiteInsert = CU_add_suite("Suite Insert Element on Stack", init_suiteInsert, clean_suiteInsert);

   if (NULL == pSuiteInsert)
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Free */
   if( (NULL == CU_add_test(pSuiteInsert, "Insert Element on stack()", testInsertElement) ) 
      || (NULL == CU_add_test(pSuiteInsert, "Insert Second Element on stack()", testInsertSecondElement) ))
   {
      CU_cleanup_registry();
      return CU_get_error();
   }


   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();


   return 0;
}
