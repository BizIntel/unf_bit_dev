﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция выполняет получение имени поля из доступных полей компоновки данных.
//
Функция ПолучитьИмяПоляВШаблоне(Знач ИмяПоля) Экспорт
	
	ИмяПоля = СтрЗаменить(ИмяПоля, ".DeletionMark", ".ПометкаУдаления");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Owner", ".Владелец");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Code", ".Код");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Parent", ".Родитель");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Predefined", ".Предопределенный");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".IsFolder", ".ЭтоГруппа");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Description", ".Наименование");
	Возврат ИмяПоля;
	
КонецФункции // ПолучитьИмяПоляВШаблоне()

#КонецОбласти

#КонецЕсли