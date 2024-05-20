defmodule PredictorWeb.LeagueLiveTest do
  use PredictorWeb.ConnCase

  import Phoenix.LiveViewTest
  import Predictor.LeaguesFixtures
  import Predictor.CompetitionsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, competition_id: nil}

  describe "Index" do
    setup [:create_competition, :create_league, :register_and_log_in_user]

    test "lists all leagues", %{conn: conn, league: league} do
      {:ok, _index_live, html} = live(conn, ~p"/leagues")

      assert html =~ "Listing Leagues"
      assert html =~ league.name
    end

    test "saves new league", %{conn: conn, competition: competition} do
      {:ok, index_live, _html} = live(conn, ~p"/leagues")

      assert index_live |> element("a", "New League") |> render_click() =~
               "New League"

      assert_patch(index_live, ~p"/leagues/new")

      assert index_live
             |> form("#league-form", league: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#league-form",
               league: Map.put(@create_attrs, :competition_id, competition.id)
             )
             |> render_submit()

      assert_patch(index_live, ~p"/leagues")

      html = render(index_live)
      assert html =~ "League created successfully"
      assert html =~ "some name"
      assert html =~ competition.name
    end

    test "updates league in listing", %{conn: conn, league: league} do
      {:ok, index_live, _html} = live(conn, ~p"/leagues")

      assert index_live |> element("#leagues-#{league.id} a", "Edit") |> render_click() =~
               "Edit League"

      assert_patch(index_live, ~p"/leagues/#{league}/edit")

      assert index_live
             |> form("#league-form", league: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#league-form",
               league: Map.put(@update_attrs, :competition_id, league.competition_id)
             )
             |> render_submit()

      assert_patch(index_live, ~p"/leagues")

      html = render(index_live)
      assert html =~ "League updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes league in listing", %{conn: conn, league: league} do
      {:ok, index_live, _html} = live(conn, ~p"/leagues")

      assert index_live |> element("#leagues-#{league.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#leagues-#{league.id}")
    end
  end

  describe "Show" do
    setup [
      :create_competition,
      :create_another_competition,
      :create_league,
      :register_and_log_in_user
    ]

    test "displays league", %{conn: conn, league: league, competition: competition} do
      {:ok, _show_live, html} = live(conn, ~p"/leagues/#{league}")

      assert html =~ "Show League"
      assert html =~ league.name
      assert html =~ competition.name
    end

    test "updates league within modal", %{
      conn: conn,
      league: league,
      another_competition: another_competition
    } do
      {:ok, show_live, _html} = live(conn, ~p"/leagues/#{league}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit League"

      assert_patch(show_live, ~p"/leagues/#{league}/show/edit")

      assert show_live
             |> form("#league-form", league: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#league-form",
               league: Map.put(@update_attrs, :competition_id, another_competition.id)
             )
             |> render_submit()

      assert_patch(show_live, ~p"/leagues/#{league}")

      html = render(show_live)
      assert html =~ "League updated successfully"
      assert html =~ "some updated name"
      assert html =~ another_competition.name
    end
  end

  defp create_league(context) do
    league = league_fixture(%{competition_id: context.competition.id})
    %{league: league}
  end

  defp create_competition(_) do
    competition = competition_fixture()
    %{competition: competition}
  end

  defp create_another_competition(_) do
    competition = competition_fixture(%{name: "another competition"})
    %{another_competition: competition}
  end
end
