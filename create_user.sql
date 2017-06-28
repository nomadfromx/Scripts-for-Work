declare
  i_USER_ID           number;
  i_RESPONSIBILITY_ID number;
  i_APPLICATION_ID    number;
  i_DESCRIPTION       VARCHAR2(240);
  i_SECURITY_GROUP_ID number;
  i_START_DATE        date;
  c_USER              VARCHAR2(30):='AIZVYAGIN';
  c_LANG                 VARCHAR2(30):='RU';
   c_RESP                 VARCHAR2(30):='Системный администратор';
  i_res               boolean;
  i_employee_id       varchar2(200);
Begin
  /*TEXT WORK IN SCHEMA APPS!!!*/
  begin
    select person_id into i_employee_id from per_all_people_f t where full_name = 'Татаркина Дина Юрьевна';
  exception when no_data_found then
    i_employee_id := null;
  end;    
  Begin
    apps.fnd_user_pkg.createuser(c_USER, 'SEED', 'Be123456', x_employee_id => i_employee_id);
  exception when others then
    dbms_output.put_line('Error <!>: '|| substr(sqlerrm,1,200));
  end;
  Begin
    select USER_ID into i_USER_ID from APPS.FND_USER FU where FU.USER_NAME = c_USER;
    i_res := apps.FND_PROFILE.SAVE('DIAGNOSTICS', 'Y', 'USER', i_USER_ID);
    if i_res = true then
      dbms_output.put_line('Профиль <Utilities:Diagnostics> был изменен для пользователя, USER_ID: '||to_char(i_USER_ID));
    else
      dbms_output.put_line('Warnings!!! Профиль <Utilities:Diagnostics> НЕ был изменен для пользователя, USER_ID: '||to_char(i_USER_ID));
    end if;
    i_res := apps.FND_PROFILE.SAVE('FND_HIDE_DIAGNOSTICS', 'N', 'USER', i_USER_ID);
    if i_res = true then
      dbms_output.put_line('Профиль <Hide Diagnostics menu entry> был изменен для пользователя, USER_ID: '||to_char(i_USER_ID));
    else
      dbms_output.put_line('Warnings!!! Профиль <Hide Diagnostics menu entry> НЕ был изменен для пользователя, USER_ID: '||to_char(i_USER_ID));
    end if;
  exception when others then
    dbms_output.put_line('Error <!>: '|| substr(sqlerrm,1,200));
  end;
  
  select FR.RESPONSIBILITY_ID, FR.APPLICATION_ID, FRT.DESCRIPTION 
    Into i_RESPONSIBILITY_ID, i_APPLICATION_ID, i_DESCRIPTION
    from APPS.FND_RESPONSIBILITY_TL FRT, APPS.FND_RESPONSIBILITY FR
   where FRT.LANGUAGE = c_LANG and FRT.RESPONSIBILITY_NAME = c_RESP and
         FRT.RESPONSIBILITY_ID = FR.RESPONSIBILITY_ID;
  
  select APPS.fnd_global.security_group_id into i_SECURITY_GROUP_ID from dual;
  
  i_START_DATE := to_date('01-10-2016','dd-mm-yyyy');
  
  dbms_output.put_line('USER_ID: '||to_char(i_USER_ID));
  dbms_output.put_line('RESPONSIBILITY_ID: '||to_char(i_RESPONSIBILITY_ID));
  dbms_output.put_line('APPLICATION_ID: '||to_char(i_APPLICATION_ID));
  dbms_output.put_line('DESCRIPTION: '||i_DESCRIPTION);
  dbms_output.put_line('SECURITY_GROUP_ID: '||to_char(i_SECURITY_GROUP_ID));
  dbms_output.put_line('i_START_DATE: '||to_date(i_START_DATE,'dd-mm-yyyy'));
  
  APPS.FND_USER_RESP_GROUPS_API.Upload_Assignment(user_id => i_USER_ID,
    responsibility_id => i_RESPONSIBILITY_ID,
    responsibility_application_id => i_APPLICATION_ID,
    security_group_id => i_SECURITY_GROUP_ID,
    start_date => i_START_DATE,
    end_date => NULL,
    description => i_DESCRIPTION);
    
 -- добавим профили
  dbms_output.put_line('Суперпользователь закупок');
  fnd_user_pkg.addresp(c_USER, 'PO', 'PURCHASING_SUPER_USER', 'STANDARD', 'Add by script', sysdate, null);
  
  dbms_output.put_line('Суперпользователь Управления заказами');
  fnd_user_pkg.addresp(c_USER, 'ONT', 'ORDER_MGMT_SUPER_USER', 'STANDARD', 'Add by script', sysdate, null);
 
  dbms_output.put_line('Запасы');
  fnd_user_pkg.addresp(c_USER, 'INV', 'INVENTORY', 'STANDARD', 'Add by script', sysdate, null);
 
  /*dbms_output.put_line('Управление затратами - SLA');
  fnd_user_pkg.addresp(c_USER, 'CST', 'COST_MANAGEMENT', 'STANDARD', 'Add by script', sysdate, null);*/
 
  dbms_output.put_line('Суперпользователь внедрения Проектов');
  fnd_user_pkg.addresp(c_USER, 'PA', 'PA_IMPLEMENTATION_SU_GUI', 'STANDARD', 'Add by script', sysdate, null);
 
  /*dbms_output.put_line('Суперпользователь Казначейства');
  fnd_user_pkg.addresp(c_USER, 'XTR', 'T', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Глобальный руководитель SLA/ЗРП');
  fnd_user_pkg.addresp(c_USER, 'PAY', 'GLB_SLA_PAYROLL_MANAGER', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Глобальный суперпользователь-руководитель СУПЕР');
  fnd_user_pkg.addresp(c_USER, 'PER', 'GLB_SHRMS_MANAGER', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Закупки для SLA');
  fnd_user_pkg.addresp(c_USER, 'PO', 'SLA_PO_DEV', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Desktop Integrator');
  fnd_user_pkg.addresp(c_USER, 'BNE', 'DESKTOP_INTEGRATOR', 'STANDARD', 'Add by script', sysdate, null);*/
 
  dbms_output.put_line('Разработчик приложений');
  fnd_user_pkg.addresp(c_USER, 'FND', 'APPLICATION_DEVELOPER', 'STANDARD', 'Add by script', sysdate, null);
 
  /*dbms_output.put_line('Администратор функций');
  fnd_user_pkg.addresp(c_USER, 'FND', 'FND_FUNC_ADMIN', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Диспетчер кредиторов');
  fnd_user_pkg.addresp(c_USER, 'SQLAP', 'PAYABLES_MANAGER', 'STANDARD', 'Add by script', sysdate, null);*/
 
  dbms_output.put_line('Администратор издателя XML');
  fnd_user_pkg.addresp(c_USER, 'XDO', 'XDO_ADMINISTRATION', 'STANDARD', 'Add by script', sysdate, null);
 
  /*dbms_output.put_line('Системный администратор');
  fnd_user_pkg.addresp(c_USER, 'SYSADMIN', 'SYSTEM_ADMINISTRATOR', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Диагностика приложения');
  fnd_user_pkg.addresp(c_USER, 'FND', 'APPLICATION_DIAGNOSTICS', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Диспетчер основных средств');
  fnd_user_pkg.addresp(c_USER, 'OFA', 'FIXED_ASSETS_MANAGER', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Диспетчер Дебиторов');
  fnd_user_pkg.addresp(c_USER, 'AR', 'RECEIVABLES_MANAGER', 'STANDARD', 'Add by script', sysdate, null);*/
 
  /*dbms_output.put_line('Суперпользователь Главной книги');
  fnd_user_pkg.addresp(c_USER, 'SQLGL', 'GENERAL_LEDGER_SUPER_USER', 'STANDARD', 'Add by script', sysdate, null);*/   
  
exception when others then
  dbms_output.put_line('Error <!>: '|| substr(sqlerrm,1,200));
end;
