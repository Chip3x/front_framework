import allure
from base.base_page import BasePage
from config.links import Links
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC


class PersonalPage(BasePage):
    PAGE_URL = Links.PERSONAL_PAGE

    EMPLOYEE_ID = ("xpath",
                   "//label[normalize-space(.)='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input")
    PERSONAL_DETAILS_SAVE_BUTTON = ("xpath", "(//button[@type='submit'])[1]")
    LOAD_SPINNER = ("xpath", "//div[@class='oxd-loading-spinner']")

    def change_employee_id(self, employee_id: str | int) -> None:
        with allure.step(f"Change Employee ID to '{employee_id}'"):
            field = self.wait.until(EC.element_to_be_clickable(self.EMPLOYEE_ID))
            field.click()
            field.clear()
            if field.get_attribute("value"):
                field.send_keys(Keys.CONTROL, "a", Keys.BACKSPACE)

            self.wait.until(lambda d: field.get_attribute("value") == "")
            field.send_keys(employee_id)

    @allure.step("Save personal details changes")
    def click_personal_details_save_button(self) -> None:
        self.wait.until(EC.element_to_be_clickable(self.PERSONAL_DETAILS_SAVE_BUTTON)).click()

    @allure.step("Get current employee id")
    def get_current_employee_id(self) -> str:
        with allure.step(f"Get current Employee ID"):
            field = self.wait.until(EC.presence_of_element_located(self.EMPLOYEE_ID))
            return field.get_attribute("value") or ""

    @allure.step("The load spinner competed")
    def wait_spinner_completed(self)-> None:
        if self.wait.until(EC.visibility_of_element_located(self.LOAD_SPINNER)):
            self.wait.until(EC.invisibility_of_element_located(self.LOAD_SPINNER))
