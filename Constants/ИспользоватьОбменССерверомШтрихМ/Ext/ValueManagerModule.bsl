﻿
Процедура ПриЗаписи(Отказ)
	
	ВыполнятьОбменССерверомШтрихМ = ЭтотОбъект.Значение;
	
	Отбор = Новый Структура();
	Отбор.Вставить("ИмяМетода", "ОбменСКассовымСерверомШтрихМ.ОбменДаннымиССерверомШтрихМ");
	
	ТаблицаЗаданий = ОчередьЗаданий.ПолучитьЗадания(Отбор);
	
	Если ТаблицаЗаданий.Количество() = 1 Тогда
		Если ТаблицаЗаданий[0].Использование <> ВыполнятьОбменССерверомШтрихМ Тогда
			ОчередьЗаданий.ИзменитьЗадание(ТаблицаЗаданий[0].Идентификатор,
				Новый Структура("Использование", ВыполнятьОбменССерверомШтрихМ));
		КонецЕсли;
	Иначе
		НашеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОбменДаннымиССерверомШтрихМ);
		Если НашеЗадание <> Неопределено Тогда
			Параметры = Новый Структура();
			Параметры.Вставить("ОбластьДанных", -1);
			Параметры.Вставить("Расписание", НашеЗадание.Расписание);
			Параметры.Вставить("Использование", ВыполнятьОбменССерверомШтрихМ);
			Параметры.Вставить("ИмяМетода", "ОбменСКассовымСерверомШтрихМ.ОбменДаннымиССерверомШтрихМ");
			
			ОчередьЗаданий.ДобавитьЗадание(Параметры);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
