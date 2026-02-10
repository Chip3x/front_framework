
import os


class Links:
    HOST = os.getenv("BASE_URL", "https://opensource-demo.orangehrmlive.com/web/index.php")
    EMP_NUMBER = os.getenv("EMP_NUMBER", "7")

    LOGIN_PAGE = f"{HOST}/auth/login"
    DASHBOARD_PAGE = f"{HOST}/dashboard/index"
    PERSONAL_PAGE = f"{HOST}/pim/viewPersonalDetails/empNumber/{EMP_NUMBER}"
