CREATE  TABLE `golfclub`.`subscriber_ios` (
  `seq` INT NOT NULL AUTO_INCREMENT ,
  `uuid` VARCHAR(10) NOT NULL DEFAULT '0' ,
  `state` TINYINT(2) NOT NULL DEFAULT '0' ,
  `role` TINYINT(4) NOT NULL DEFAULT '0' ,
  `memo` VARCHAR(128) NULL DEFAULT NULL ,
  `update_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  `login_username` VARCHAR(16) NULL DEFAULT NULL ,
  PRIMARY KEY (`seq`) ,
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC) );
  
  
  
  
  CREATE  TABLE `golfclub`.`subscriber_ios_receipt` (
  `seq` INT(11) NOT NULL AUTO_INCREMENT ,
  `subscriber_uuid` VARCHAR(10) NOT NULL ,
  `service_start_date` DATETIME NULL DEFAULT NULL ,
  `service_stop_date` DATETIME NULL DEFAULT NULL ,
  `update_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`seq`) ,
  INDEX `subscriber_ios_receipt_idx` (`subscriber_uuid` ASC) ,
  CONSTRAINT `subscriber_ios_receipt_fk_subscriber_ios`
    FOREIGN KEY (`subscriber_uuid` )
    REFERENCES `golfclub`.`subscriber_ios` (`uuid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
