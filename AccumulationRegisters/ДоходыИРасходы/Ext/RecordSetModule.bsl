﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	// Хозяйственная операция
	ХозяйственныеОперацииСервер.ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(ЭтотОбъект);
	// Конец Хозяйственная операция
	
КонецПроцедуры // ПередЗаписью()

#КонецОбласти

#КонецЕсли