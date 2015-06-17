#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "linked_list.h"

list_header *header = NULL;
node* element = NULL;

/* The suite initialization function.
 * Opens the temporary file used by the tests.
 * Returns zero on success, non-zero otherwise.
 */
int init_suite1(void)
{
   element = build_new_node(1, 1, 2, 2,
                "string", "node1", "main", "Variable");

   header = new_linked_list();
   header = insert_element(header, element);
   return 0;
}
/* The suite cleanup function.
 * Closes the temporary file used by the tests.
 * Returns zero on success, non-zero otherwise.
 */
int clean_suite1(void)
{
   free_linked_list(header);
   header = NULL;
   return 0;
}

int init_suite_insert(void){
   init_suite1();

   header = insert_element(header, element);

   return 0;
}
int clean_suite_insert(void)
{  
   free_linked_list(header);
   header = NULL;
   return 0;
}

/* add the tests to the suite Create*/
void testLinkedListCreating(void)
{
   CU_ASSERT( header != NULL);
}
void testNodeCreating(void){
   CU_ASSERT_PTR_NOT_NULL(element);
   CU_ASSERT(element->id == 1);
   CU_ASSERT_STRING_EQUAL(element->type, "string");
}

/* add the tests to the suite Insert*/
void testInsertNode(void)
{
   CU_ASSERT_PTR_EQUAL(header, insert_element(header, element));
}
void testInsertNodeNumber(void)
{
   CU_ASSERT(header->length == 3);
}
void testInsertFirstNode(void)
{
   header = new_linked_list();
   header = insert_element(header, element);

   CU_ASSERT(header->length == 1);
}

/*add tests to the suite Search*/
void testSearchingAllocatedNode(void)
{
   node* findedElement = search_element(header, element->identifier);
   CU_ASSERT( findedElement == element);
}
void testSearchingNodeWithWrongIdentifier(void)
{
   node* findedElement = search_element(header, "not");
   CU_ASSERT_PTR_NULL(findedElement);
}
// Depends on remove function
void testSearchingDeallocatedNode(void)
{  
   //node* findedElement = search_element(header, "nodeRemoved");
   //CU_ASSERT_PTR_NULL(findedElement);
   CU_ASSERT_PTR_NULL(NULL);
}

/* add tests to the suite Free Linked List*/
void testFreeLinkedList(void)
{
   free_linked_list(header);
   CU_ASSERT_PTR_NULL(header->head);
   CU_ASSERT_PTR_NULL(header->tail);
   CU_ASSERT(header->length == 0);
}

int main()
{
	 CU_pSuite pSuite = NULL;
    CU_pSuite pSuiteInsert = NULL;
    CU_pSuite pSuiteSearchNode = NULL;
    CU_pSuite pSuiteFree = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite_Create", init_suite1, clean_suite1);
   pSuiteInsert = CU_add_suite("Suite_Insert", init_suite_insert, clean_suite_insert);
   pSuiteSearchNode = CU_add_suite("Suite_SearchNode", init_suite1, clean_suite1);
   pSuiteFree = CU_add_suite("Suite_Free", init_suite1, clean_suite1);

   //Adding suite node to the registry
   if ((NULL == pSuiteInsert)
      || (NULL == pSuite)
      || (NULL == pSuiteSearchNode)
      || (NULL == pSuiteFree)
      )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Create */
   if ((NULL == CU_add_test(pSuite, "test list is created()", testLinkedListCreating))
      || (NULL == CU_add_test(pSuite, "test build new node()", testNodeCreating))
      )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Insert */
   if ((NULL == CU_add_test(pSuiteInsert, "insert new node()", testInsertNode))
      || (NULL == CU_add_test(pSuiteInsert, "number of nodes()", testInsertNodeNumber))
      || (NULL == CU_add_test(pSuiteInsert, "insert first node()", testInsertFirstNode))
      )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Search */
   if ((NULL == CU_add_test(pSuiteSearchNode, "testSearchingAllocatedNode()", testSearchingAllocatedNode))
         || (NULL == CU_add_test(pSuiteSearchNode, "testSearchingNodeWithWrongIdentifier()", testSearchingNodeWithWrongIdentifier))
         || (NULL == CU_add_test(pSuiteSearchNode, "testSearchingDeallocatedNode()", testSearchingDeallocatedNode))
         )
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Suite Free */
   if( (NULL == CU_add_test(pSuiteFree, "free linked list()", testFreeLinkedList) ))
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();

	return 0;
}
 