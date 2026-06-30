**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,t_tests_pr

dcl-proc Main;
  dcl-pi *n end-pi;

  TestRules01();
  TestRules02();
  TestRules03();
  TestRules04();
  TestRules05();
  TestRules06();
  TestRules07();
  TestRules08();
  TestRules09();
  TestRules10();
  TestRules11();
  TestRules12();

  TestData01();
  TestData02();
  TestData03();
  TestData04();
  TestData05();

  TestJson01();
  TestJson02();

  TestIfs01();
  TestIfs02();
  TestIfs03();

  TestLog01();
  TestBatch01();

  dsply 'Suite GLBLN finalizada';
  *inlr = *on;
end-proc;
