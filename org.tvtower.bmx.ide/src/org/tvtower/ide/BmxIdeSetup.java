/*
 * generated by Xtext 2.23.0
 */
package org.tvtower.ide;

import com.google.inject.Guice;
import com.google.inject.Injector;
import org.eclipse.xtext.util.Modules2;
import org.tvtower.BmxRuntimeModule;
import org.tvtower.BmxStandaloneSetup;

/**
 * Initialization support for running Xtext languages as language servers.
 */
public class BmxIdeSetup extends BmxStandaloneSetup {

	@Override
	public Injector createInjector() {
		return Guice.createInjector(Modules2.mixin(new BmxRuntimeModule(), new BmxIdeModule()));
	}
	
}
