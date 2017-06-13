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
	|	НДФЛДоходы.НомерСтроки КАК НомерСтроки,
	|	НДФЛДоходы.Организация КАК Организация,
	|	НДФЛДоходы.Сотрудник КАК Сотрудник,
	|	НДФЛДоходы.ПериодРегистрации КАК ПериодРегистрации,
	|	НДФЛДоходы.КодДохода КАК КодДохода,
	|	НДФЛДоходы.КодВычета КАК КодВычета,
	|	НДФЛДоходы.СуммаДохода КАК СуммаДоходаПередЗаписью,
	|	НДФЛДоходы.СуммаДохода КАК СуммаДоходаИзменение,
	|	НДФЛДоходы.СуммаДохода КАК СуммаДоходаПриЗаписи,
	|	НДФЛДоходы.СуммаВычета КАК СуммаВычетаПередЗаписью,
	|	НДФЛДоходы.СуммаВычета КАК СуммаВычетаИзменение,
	|	НДФЛДоходы.СуммаВычета КАК СуммаВычетаПриЗаписи
	|ПОМЕСТИТЬ ДвиженияНДФЛДоходыИзменение
	|ИЗ
	|	РегистрНакопления.НДФЛДоходы КАК НДФЛДоходы");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияНДФЛДоходыИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#КонецОбласти

#КонецЕсли