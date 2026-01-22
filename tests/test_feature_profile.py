import pytest
import allure
from base.base_test import BaseTest

@allure.feature("Profile Functionality")
class TestPersonaProfile(BaseTest):

    @allure.title("Change Employee ID")
    @allure.severity("Critical")
    @pytest.mark.parametrize("employee_id", ["234", "3ver212"])
    @pytest.mark.smoke
    def test_change_employee_id(self, employee_id):
        self.login_page.open()
        self.login_page.enter_login(self.data.LOGIN)
        self.login_page.enter_password(self.data.PASSWORD)
        self.login_page.click_submit()

        self.dashboard_page.click_my_info()

        self.personal_page.wait_spinner_completed()
        self.personal_page.change_employee_id(employee_id)
        self.personal_page.click_personal_details_save_button()
        self.personal_page.wait_spinner_completed()
        self.personal_page.make_screenshot("Success")
        assert self.personal_page.get_current_employee_id() == employee_id, "Employee ID doesn't match"
