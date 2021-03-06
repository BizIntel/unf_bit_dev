﻿&НаКлиенте
// Функция определяет разность дат в месяцах.
//
Функция СрокПоДатеОкончания(ДатаОкончания, ДатаНачала) Экспорт
	
	Если ДатаОкончания < ДатаНачала Тогда
		Возврат 0;
	КонецЕсли;
	
	ГодНачала = Год(ДатаНачала);
	ГодОкончания = Год(ДатаОкончания);
	
	МесяцНачала = Месяц(ДатаНачала);
	МесяцОкончания = Месяц(ДатаОкончания);
	
	ДеньНачала = День(ДатаНачала);
	ДеньОкончания = День(ДатаОкончания);
	
	Возврат Макс(((ГодОкончания - ГодНачала) - ?(МесяцОкончания < МесяцНачала, 1, 0)), 0) * 12
		+ (МесяцОкончания - МесяцНачала + 1 + ?(МесяцОкончания < МесяцНачала, 12, 0) - ?(ДеньОкончания < ДеньНачала, 1, 0));
	
КонецФункции

&НаКлиенте
// Выполняет расчет коэффициента для аннуитетных платежей.
//
// Параметры:
//	- Ставка, тип число - процентная ставка за период погашения (месяц).
//	- Срок, тип Число - количество периодов погашения (месяцев).
//
Функция КоэффициентАннуитета(Ставка, Срок) Экспорт
	
	Если Срок = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	Если Ставка = 0 Тогда
		Возврат 1 / Срок;
	КонецЕсли;
	
	Возврат Ставка / (1 - Pow(1 + Ставка, - Срок));
	
КонецФункции

&НаКлиенте
Функция ПроцентнаяСтавкаЗаМесяц(ПроцентнаяСтавкаГодовая) Экспорт
	
	Если ПроцентнаяСтавкаГодовая = 0 Тогда
		Возврат 0;
	Иначе
		//Возврат (POW((100+ПроцентнаяСтавкаГодовая)*0.01, 1/12) - 1) * 100;
		Возврат ПроцентнаяСтавкаГодовая / 12;
	КонецЕсли;
	
КонецФункции
