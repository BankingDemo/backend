package com.redhat.banking;

import java.sql.Connection;
import java.sql.SQLException;

import javax.annotation.PostConstruct;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.jdbc.datasource.init.ScriptStatementFailedException;

@Singleton
@Startup
public class DatabasePopulator {
	private final Logger logger = Logger.getLogger(DatabasePopulator.class);

	@PostConstruct
	private void startup() throws NamingException, SQLException { 
		Context jndiContext = new InitialContext();
        DataSource dataSource = (DataSource)jndiContext.lookup("java:jboss/datasources/MySqlDS");

		ResourceDatabasePopulator rdp = new ResourceDatabasePopulator();    
		rdp.addScript(new ClassPathResource("import.sql"));

		Connection connection = dataSource.getConnection();
		try {
			rdp.populate(connection);
		} catch(ScriptStatementFailedException e) {
			logger.error(e);
		}
	}
}
