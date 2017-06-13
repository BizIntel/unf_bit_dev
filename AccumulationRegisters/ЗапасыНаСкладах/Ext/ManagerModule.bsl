﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ЗапасыНаСкладах.НомерСтроки КАК НомерСтроки,
	|	ЗапасыНаСкладах.Организация КАК Организация,
	|	ЗапасыНаСкладах.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыНаСкладах.Номенклатура КАК Номенклатура,
	|	ЗапасыНаСкладах.Характеристика КАК Характеристика,
	|	ЗапасыНаСкладах.Партия КАК Партия,
	|	ЗапасыНаСкладах.Ячейка КАК Ячейка,
	|	ЗапасыНаСкладах.Количество КАК КоличествоПередЗаписью,
	|	ЗапасыНаСкладах.Количество КАК КоличествоИзменение,
	|	ЗапасыНаСкладах.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыНаСкладахИзменение
	|ИЗ
	|	РегистрНакопления.ЗапасыНаСкладах КАК ЗапасыНаСкладах");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыНаСкладахИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#КонецОбласти

#КонецЕсли