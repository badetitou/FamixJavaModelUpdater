package fr.badetitou.association;

import fr.badetitou.external.ExternalFamixJavaClass;
import fr.badetitou.exception.MyException;
import fr.badetitou.interfaces.MyInterface;
import fr.badetitou.association.mysuper.MySuperClass;

public class MyClass extends MySuperClass implements MyInterface {

	MyParametrizable<Object> parametrized = new MyParametrizable<Object>(); 

	ExternalFamixJavaClass methodM() throws MyException { 
		return null;
	}

	void aMethod() {
		int localVariable;
		int localVariableWithInitialization = 0;
	}

	void aMethodWithInvocation() {
		ExternalFamixJavaClass myExternalFamixJavaClass = new ExternalFamixJavaClass();
		myExternalFamixJavaClass.externalFamixJavaMethod();
	}

	void localCall() {
		aMethod();
	}


	void aSuperMethodCall() {
		aSuperMethod();
	}

	void aParametrizedTypeMethodCall() {
		parametrized.myMethod();
	}

}