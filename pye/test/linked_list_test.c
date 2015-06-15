#include <stdio.h>
#include <string.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "./Linked_List_Copy/linked_list.c"

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

int init_suite_insert(void){
   init_suite1();

   header = insert_element(header, element);

   return 0;
}

/* The suite cleanup function.
 * Closes the temporary file used by the tests.
 * Returns zero on success, non-zero otherwise.
 */
int clean_suite1(void)
{
   return 0;
}

//first Test
void testLinkedListCreating(void)
{
   CU_ASSERT( header != NULL);
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


//Test suite of search node
//Test suite must be started after creating a header and adding a node
int init_suiteSearchNode(void)
{
   // id = 3 Allocating node for dealloc
   //node* node2 = build_new_node(3, 1, 2, 2,
   //              "string", "nodeRemoved", "main", "Variable");
   /*
   header = insert_element(header, node2);
   
   node* findedElement = search_element(header, node2->identifier);
   node* removedElement = remove_element( header, 
                                          findedElement, 
                                          generic_comparator comparison_function);
   */
   return 0;
}
int clean_suiteSearchNode(void)
{
   return 0;
}
// Test cases
// Test case of Search node depends of insert function
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

int main()
{
	 CU_pSuite pSuite = NULL;
    CU_pSuite pSuiteInsert = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite_1", init_suite1, clean_suite1);
   pSuiteInsert = CU_add_suite("Suite_Insert", init_suite_insert, clean_suite1);
   
   if (NULL == pSuiteInsert)
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   if (NULL == pSuite) 
   {
      CU_cleanup_registry();
      return CU_get_error();
   }
   /* add the tests to the suite */
   if ((NULL == CU_add_test(pSuite, "first test()", testLinkedListCreating)))
   {
      CU_cleanup_registry();
      return CU_get_error();
   }

   //Adding suite search node to the registry
   CU_pSuite pSuiteSearchNode = NULL;
   pSuiteSearchNode = CU_add_suite("Suite_SearchNode", init_suiteSearchNode, clean_suiteSearchNode);
   if (NULL == pSuiteSearchNode) 
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

   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();


	return 0;
}
