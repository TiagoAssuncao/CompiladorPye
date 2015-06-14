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

int main()
{
	 CU_pSuite pSuite = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite_1", init_suite1, clean_suite1);
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

   // Run all tests using the CUnit Basic interface
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();
   CU_cleanup_registry();
   return CU_get_error();


	return 0;
}
