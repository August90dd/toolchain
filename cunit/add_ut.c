#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "add.h"

void test_add()
{
	CU_ASSERT_EQUAL(add(0, 0), 0);
	CU_ASSERT_EQUAL(add(0, 1), 1);
	CU_ASSERT_EQUAL(add(1, 0), 1);
	CU_ASSERT_EQUAL(add(1, -1), 0);
}

// http://cunit.sourceforge.net/example.html
int main()
{
	/* initialize the CUnit test registry */
	if (CUE_SUCCESS != CU_initialize_registry())
		return CU_get_error();

	/* add a suite to the registry */
	CU_pSuite pSuite = CU_add_suite("Suite_1", NULL, NULL);
	if (NULL == pSuite)
		goto cleanup;

	/* add the tests to the suite */
	if (NULL == CU_add_test(pSuite, "test add()", test_add))
		goto cleanup;

	CU_basic_set_mode(CU_BRM_VERBOSE);

	CU_basic_run_tests();

 cleanup:
	CU_cleanup_registry();
	return CU_get_error();
}
