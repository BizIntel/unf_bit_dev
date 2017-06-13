﻿
#Область ПрограммныйИнтерфейс

Функция ОтписатьсяОтЛентыНовостей(ЛентаИлиНовость, ИмяПользователяИБ = "") Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Успешно", Ложь);
	Результат.Вставить("ЛентаНовостей", Неопределено);
	Результат.Вставить("ПредставлениеЛентыНовостей", "");
	
	Если Не ЗначениеЗаполнено(ЛентаИлиНовость) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЛентаНовостей = ЛентаИлиНовость;
	
	Если ТипЗнч(ЛентаИлиНовость) = Тип("СправочникСсылка.Новости") Тогда
		ЛентаНовостей = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЛентаИлиНовость, "ЛентаНовостей");
	КонецЕсли;
	
	Результат.ЛентаНовостей = ЛентаНовостей;
	Результат.ПредставлениеЛентыНовостей = Строка(ЛентаНовостей);
	
	МассивОтключенныхЛентНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
		"ОтключенныеЛентыНовостей",
		"",
		,
		ИмяПользователяИБ
	);
	
	Если ТипЗнч(МассивОтключенныхЛентНовостей) <> Тип("Массив") Тогда
		МассивОтключенныхЛентНовостей = Новый Массив;
	КонецЕсли;
	
	Если МассивОтключенныхЛентНовостей.Найти(ЛентаНовостей) = Неопределено Тогда
		
		МассивОтключенныхЛентНовостей.Добавить(ЛентаНовостей);
		
		ХранилищаНастроек.НастройкиНовостей.Сохранить(
			"ОтключенныеЛентыНовостей",
			"",
			МассивОтключенныхЛентНовостей,
			,
			ИмяПользователяИБ
		);
		
		Результат.Успешно = Истина;
		Возврат Результат;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти