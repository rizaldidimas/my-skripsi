x = [6, 4, 11, 13, 15, 14, 13, 11, 9, 1, 7, 11, 13, 15, 8];
y = [11, 13, 16, 17, 17, 14, 12, 15, 12, 9, 4, 4, 8, 9, 9];

dist_matrix = [
  0, 9, 15, 23, 21, 15, 14, 6, 13, 11, 21, 27, 12, 15, 5;
  9, 0, 15, 21, 23, 19, 20, 11, 17, 12, 19, 22, 18, 20, 10;
  14, 13, 0, 5, 8, 8, 12, 9, 10, 24, 27, 29, 18, 21, 17;
  17, 21, 5, 0, 4, 5, 9, 11, 5, 30, 28, 25, 15, 17, 19;
  10, 22, 8, 4, 0, 5, 10, 12, 7, 31, 30, 26, 16, 18, 20;
  14, 21, 8, 5, 5, 0, 6, 8, 5, 27, 25, 22, 12, 14, 16;
  14, 20, 12, 9, 10, 6, 0, 10, 9, 25, 19, 16, 6, 8, 14;
  6, 11, 10, 11, 12, 8, 10, 0, 7, 24, 24, 26, 15, 18, 15;
  13, 11, 10, 11, 12, 8, 10, 7, 0, 19, 17, 19, 13, 15, 8;
  11, 12, 24, 30, 31, 27, 25, 24, 19, 0, 15, 21, 21, 26, 11;
  21, 19, 27, 28, 30, 25, 19, 24, 17, 15, 0, 6, 13, 19, 10;
  27, 22, 29, 25, 26, 22, 16, 26, 19, 21, 6, 0, 10, 13, 12;
  12, 18, 18, 15, 16, 12, 6, 15, 13, 21, 13, 10, 0, 4, 10;
  15, 20, 21, 17, 18, 14, 8, 18, 15, 26, 19, 13, 4, 0, 12;
  5, 10, 17, 19, 20, 16, 14, 15, 8, 11, 10, 12, 10, 12, 0
];

num_ants = 100;
num_iterations = 100;
alpha = 1;
beta = 2;
evaporation_rate = 0.5;
q = 100;

% Fungsi utama untuk menjalankan ACO
function best_route = ant_colony_optimization(dist_matrix, num_ants, num_iterations, alpha, beta, evaporation_rate, q, x, y)

  % Inisialisasi
  num_cities = size(dist_matrix, 1);
  pheromone_matrix = ones(num_cities);
  best_route = [];
  best_route_length = Inf;

  % Iterasi ACO
  for iteration = 1:num_iterations

    % Menyimpan rute semua semut dalam satu iterasi
    routes = zeros(num_ants, num_cities);
    route_lengths = zeros(num_ants, 1);

    for ant = 1:num_ants

      % Semua semut memulai dari titik 1
      current_city = 1;
      route = zeros(1, num_cities);
      route(1) = current_city;
      visited = false(1, num_cities);
      visited(current_city) = true;

      % Membangun rute untuk satu semut
      for step = 2:num_cities
        probabilities = calculate_transition_probabilities(current_city, visited, pheromone_matrix, dist_matrix, alpha, beta);
        next_city = roulette_wheel_selection(probabilities);
        route(step) = next_city;
        visited(next_city) = true;
        current_city = next_city;
      end

      routes(ant, :) = route;
      route_lengths(ant) = calculate_route_length(route, dist_matrix);
    end

    % Memperbarui matriks pheromone
    pheromone_matrix = update_pheromone_matrix(pheromone_matrix, routes, route_lengths, evaporation_rate, q);

    % Menentukan rute terbaik dalam iterasi ini
    [min_length, best_ant] = min(route_lengths);
    if min_length < best_route_length
      best_route_length = min_length;
      best_route = routes(best_ant, :);
    end

    % Menampilkan rute setiap semut dalam iterasi ini
    %fprintf('Iteration %d: \n', iteration);
    %for iterations = 1:num_iterations
    %  fprintf('Iterasi %d: Route = %s\n', ant, mat2str(routes(ant, :)));
    %end

    % Menampilkan urutan titik kunjungan pada setiap iterasi
    fprintf('Iteration %d: Best route = %s, Length = %.2f\n', iteration, mat2str(best_route), best_route_length);
  end

  % Menampilkan rute terbaik yang ditemukan
  fprintf('Best route found: %s\n', mat2str(best_route));
end

% Fungsi untuk menghitung probabilitas transisi
function probabilities = calculate_transition_probabilities(current_city, visited, pheromone_matrix, dist_matrix, alpha, beta)
  num_cities = length(visited);
  probabilities = zeros(1, num_cities);
  for city = 1:num_cities
    if ~visited(city)
      probabilities(city) = (pheromone_matrix(current_city, city) ^ alpha) * ((1 / dist_matrix(current_city, city)) ^ beta);
    end
  end
  probabilities = probabilities / sum(probabilities);
end

% Fungsi untuk memilih kota berikutnya berdasarkan probabilitas transisi
function next_city = roulette_wheel_selection(probabilities)
  cumulative_probabilities = cumsum(probabilities);
  r = rand();
  next_city = find(cumulative_probabilities >= r, 1);
end

% Fungsi untuk menghitung panjang rute
function route_length = calculate_route_length(route, dist_matrix)
  route_length = 0;
  num_cities = length(route);
  for i = 1:(num_cities - 1)
    route_length = route_length + dist_matrix(route(i), route(i + 1));
  end
  route_length = route_length + dist_matrix(route(num_cities), route(1)); % Kembali ke kota awal
end

% Fungsi untuk memperbarui matriks pheromone
function pheromone_matrix = update_pheromone_matrix(pheromone_matrix, routes, route_lengths, evaporation_rate, q)
  num_cities = size(pheromone_matrix, 1);
  pheromone_matrix = (1 - evaporation_rate) * pheromone_matrix;

  for i = 1:size(routes, 1)
    route = routes(i, :);
    route_length = route_lengths(i);
    for j = 1:(num_cities - 1)
      pheromone_matrix(route(j), route(j + 1)) = pheromone_matrix(route(j), route(j + 1)) + q / route_length;
    end
    pheromone_matrix(route(num_cities), route(1)) = pheromone_matrix(route(num_cities), route(1)) + q / route_length; % Kembali ke kota awal
  end
end

% Fungsi untuk menampilkan rute terbaik
function plot_route(route, x, y)
  route = [route, route(1)]; % Menambahkan kota awal ke akhir rute
  plot(x(route), y(route), 'o-', 'LineWidth', 2, 'MarkerSize', 6);
  title('Best Route Found by Ant Colony Optimization');
  xlabel('X Coordinate');
  ylabel('Y Coordinate');
  grid on;
end

best_route = ant_colony_optimization(dist_matrix, num_ants, num_iterations, alpha, beta, evaporation_rate, q, x, y);
disp('Best route found:');
disp(best_route);
