package fr.badetitou.association;

import fr.badetitou.external.ExternalFamixJavaClass;
import fr.badetitou.exception.MyException;
import fr.badetitou.interfaces.MyInterface;
import fr.badetitou.association.mysuper.MySuperClass;

public class MyClass extends MySuperClass implements MyInterface {

	MyParametrizable<Object> parametrized = new MyParametrizable<Object>();
	MyParametrizable parametrizable = new MyParametrizable(); 


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
		this.aMethod();
	}


	void aSuperMethodCall() {
		aSuperMethod();
	}

	void aParametrizedTypeMethodCall() {
		parametrized.myMethod();
	}

	void aParametrizableTypeMethodCall() {
		parametrizable.myMethod();
	}

	private synchronized MyClass methodMyClass() {
		return new MyClass();
	}

}