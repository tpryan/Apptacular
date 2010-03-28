component extends="mxunit.framework.TestCase"{
	
	public void function testCities(){
    
		var starting = "cities";
		var expected = "city";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
	
	public void function testPersons(){
		var starting = "persons";
		var expected = "person";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
	
	public void function testCountries(){
		var starting = "countries";
		var expected = "country";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
	
	public void function testE2p(){
		var starting = "e2p";
		var expected = "e2p";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
	
	public void function testPresenters(){
		var starting = "presenters";
		var expected = "presenter";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
	
	public void function testRadii(){
		var starting = "radii";
		var expected = "radius";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
	
	public void function testEva_Presenters(){
		var starting = "eva_presenters";
		var expected = "eva_presenter";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
	
	public void function testEva_users_social(){
		var starting = "eva_users_social";
		var expected = "eva_users_social";
		var stringUtil = New apptacular.handlers.cfc.stringUtil();
		var actual = stringUtil.depluralize(starting);
		AssertEquals(expected, actual);
    }
    

}