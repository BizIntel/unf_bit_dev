﻿
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРегистрациюВИФНС();
	
КонецПроцедуры


Процедура ЗаполнитьРегистрациюВИФНС()
	
	Если ИспользоватьИФНСТорговойТочки Тогда
		
		Если ЗначениеЗаполнено(РегистрацияВИФНС) Тогда
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "Код") = КодИФНС Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	РегистрацииВНалоговомОргане.Ссылка
			|ИЗ
			|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
			|ГДЕ
			|	РегистрацииВНалоговомОргане.Код = &Код
			|	И НЕ РегистрацииВНалоговомОргане.ПометкаУдаления");
		
		Запрос.УстановитьПараметр("Код", КодИФНС);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() ТОгда
			РегистрацияВИФНС = Выборка.Ссылка;
		Иначе
			НоваяРегистрация = Справочники.РегистрацииВНалоговомОргане.СоздатьЭлемент();
			НоваяРегистрация.Наименование = НСтр("ru='Регистрация к торговой точке'") + Наименование;
			НоваяРегистрация.Код = КодИФНС;
			НоваяРегистрация.КодПоОКТМО = КодПоОКТМО;
			НоваяРегистрация.КПП  =ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец,"КПП");
			НоваяРегистрация.НаименованиеИФНС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НалоговыеОрганы.НайтиПоКоду(КодИФНС),"Наименование");
			НоваяРегистрация.Владелец = Владелец;
			НоваяРегистрация.Записать();
			РегистрацияВИФНС = НоваяРегистрация.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	
КонецПроцедуры

