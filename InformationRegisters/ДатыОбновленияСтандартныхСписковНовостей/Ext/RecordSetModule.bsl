﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ТипСтрока            = Тип("Строка");
	ТипКатегорияНовостей = Тип("ПланВидовХарактеристикСсылка.КатегорииНовостей");

	// Список может быть либо типа ПланВидовХарактеристик,
	//  либо строка с определенными значениями ("Список категорий новостей", "Список лент новостей").

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если ТипЗнч(ТекущаяЗапись.Список) = ТипКатегорияНовостей Тогда
			Если ТекущаяЗапись.Список.Пустая() Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ТекущаяЗапись);
				Сообщение.Поле = "Список";
				Сообщение.ПутьКДанным = "Запись";
				Сообщение.Текст = НСтр("ru='Значение обновляемой категории должно быть заполнено.'");
				Сообщение.Сообщить();
			КонецЕсли;
		ИначеЕсли ТипЗнч(ТекущаяЗапись.Список) = ТипСтрока Тогда
			Если ТекущаяЗапись.Список = "Список категорий новостей" Тогда
				// Разрешенное значение
			ИначеЕсли ТекущаяЗапись.Список = "Список лент новостей" Тогда
				// Разрешенное значение
			ИначеЕсли Найти(ВРег(ТекущаяЗапись.Список), ВРег("Значения категории новостей:")) = 1 Тогда
				// Разрешенное значение
			Иначе
				// Неразрешенное значение
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ТекущаяЗапись);
				Сообщение.Поле = "Список";
				Сообщение.ПутьКДанным = "Запись";
				Сообщение.Текст = СтрШаблон(
					НСтр("ru='Неправильное значение %1.
						|Разрешено только:
						|- Список категорий новостей
						|- Список лент новостей
						|- Код категории новостей (начинается с [Значения категории новостей:])'"),
					ТекущаяЗапись.Список);
				Сообщение.Сообщить();
			КонецЕсли;
		Иначе
			// Неразрешенное значение
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ТекущаяЗапись);
			Сообщение.Поле = "Список";
			Сообщение.ПутьКДанным = "Запись";
			Сообщение.Текст = СтрШаблон(
				НСтр("ru='Неправильное значение %1.
					|Разрешено только:
					|- Список категорий новостей
					|- Список лент новостей
					|- Код категории новостей (начинается с [Значения категории новостей:])
					|- Ссылка на план видов характеристик КатегорииНовостей'"),
				ТекущаяЗапись.Список);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли